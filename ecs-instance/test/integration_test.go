// +build integration

package test

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type ECSInstanceInfo struct {
	IP string `json:"ip"`
}

func TestECSInstanceModuleIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		Logger:       logger.Discard,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "instance_info")
	sshKey := terraform.Output(t, terraformOptions, "private_key")
	sshUser := terraform.Output(t, terraformOptions, "user")

	var instanceInfo ECSInstanceInfo
	require.NoError(t, json.Unmarshal([]byte(output), &instanceInfo))

	host := ssh.Host{
		Hostname:    instanceInfo.IP,
		SshUserName: sshUser,
		SshKeyPair: &ssh.KeyPair{
			PrivateKey: sshKey,
		},
	}
	retry.DoWithRetry(t, "Attempting to ssh into ec2 host", 60, 5*time.Second, func() (string, error) {
		// check that the public key sync happened
		if err := ssh.CheckSshConnectionE(t, host); err != nil {
			return "", err
		}
		// check to make sure we have our persistent mount
		return ssh.CheckSshCommandE(t, host, "ls /data")
	})
}
