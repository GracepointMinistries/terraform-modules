// +build integration

package test

import (
	"encoding/json"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

type VPCInfo struct {
	ID                string   `json:"vpc"`
	AvailabilityZones []string `json:"azs"`
	Subnets           []string `json:"subnet_ids"`
}

func TestVPCModuleIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Logger:       logger.Discard,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "vpc_info")

	var vpcInfo VPCInfo
	require.NoError(t, json.Unmarshal([]byte(output), &vpcInfo))

	require.Equal(t, []string{"us-east-1a", "us-east-1b"}, vpcInfo.AvailabilityZones)
	require.Len(t, vpcInfo.Subnets, 2)

	vpc := aws.GetVpcById(t, vpcInfo.ID, "us-east-1")
	require.Len(t, vpc.Subnets, 2)

	for _, subnet := range vpc.Subnets {
		found := false
		for i, az := range vpcInfo.AvailabilityZones {
			if az == subnet.AvailabilityZone {
				require.Equal(t, vpcInfo.Subnets[i], subnet.Id)
				found = true
			}
		}
		require.True(t, found)
	}
}
