// +build !integration

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestVPCModuleUnit(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Logger:       logger.Discard,
	}

	terraform.Init(t, terraformOptions)
	output := terraform.InitAndPlan(t, terraformOptions)

	// first subnet
	require.Contains(t, output, "10.0.0.0/24")
	// second subnet
	require.Contains(t, output, "10.0.1.0/24")
	// total resources
	require.Contains(t, output, "8 to add, 0 to change, 0 to destroy")
}
