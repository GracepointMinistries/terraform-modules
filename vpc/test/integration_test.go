// +build integration

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestVPCModuleIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	azs := terraform.Output(t, terraformOptions, "azs")
	require.Equal(t, []string{"us-east-1a", "us-east-1b"}, azs)
	vpcID := terraform.Output(t, terraformOptions, "vpc")
	vpc := aws.GetVpcById(t, vpcID, "us-east-1")
	require.Len(t, vpc.Subnets, 2)
}
