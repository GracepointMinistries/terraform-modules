// +build integration

package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type UserInfo struct {
	Users []string `json:"users"`
}

func TestGithubIAMUsersModuleIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Logger:       logger.Discard,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	output := terraform.Output(t, terraformOptions, "user_info")

	var userInfo UserInfo
	require.NoError(t, json.Unmarshal([]byte(output), &userInfo))

	require.Equal(t, []string{"andrewstucki", "gracepoint-ops"}, userInfo.Users)
}
