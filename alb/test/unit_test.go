// +build !integration

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestALBModuleUnit(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../example",
		Logger:       logger.Discard,
	}

	terraform.Init(t, terraformOptions)
	output := terraform.InitAndPlan(t, terraformOptions)

	// wildcard check
	require.Contains(t, output, "*.testing.gracepointonline.org")
	// proper principal resolution
	require.Contains(t, output, "arn:aws:iam::127311923021:root")
	// total resources
	require.Contains(t, output, "27 to add, 0 to change, 0 to destroy")
}
