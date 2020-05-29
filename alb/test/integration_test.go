// +build integration

package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type ALBInfo struct {
	Record      string `json:"record"`
	ALBZone     string `json:"alb_zone"`
	ListenerARN string `json:"listener"`
	Domain      string `json:"domain"`
	Zone        string `json:"zone"`
}

func TestALBModuleIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Logger:       logger.Discard,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "alb_info")

	var albInfo ALBInfo
	require.NoError(t, json.Unmarshal([]byte(output), &albInfo))

	// from https://docs.aws.amazon.com/general/latest/gr/elb.html
	require.Equal(t, "Z35SXDOTRQ7X7K", albInfo.ALBZone)
	require.Equal(t, "testing.gracepointonline.org", albInfo.Domain)
	require.NotEqual(t, "", albInfo.ListenerARN)
	require.NotEqual(t, "", albInfo.Record)
	require.NotEqual(t, "", albInfo.Zone)
}
