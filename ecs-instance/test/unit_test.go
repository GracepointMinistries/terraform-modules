// +build !integration

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestECSInstanceModuleUnit(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Logger:       logger.Discard,
	}

	terraform.Init(t, terraformOptions)
	output := terraform.InitAndPlan(t, terraformOptions)

	// total resources
	require.Contains(t, output, "35 to add, 0 to change, 0 to destroy")
}
