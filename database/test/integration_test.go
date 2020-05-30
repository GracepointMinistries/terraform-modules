// +build integration

package test

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	_ "github.com/lib/pq"
	"github.com/stretchr/testify/require"
)

type DatabaseInfo struct {
	ConnectionString string `json:"connection_string"`
	ID               string `json:"id"`
}

func TestDatabaseModuleIntegration(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		Logger:       logger.Discard,
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	output := terraform.Output(t, terraformOptions, "database_info")

	var databaseInfo DatabaseInfo
	require.NoError(t, json.Unmarshal([]byte(output), &databaseInfo))

	address := aws.GetAddressOfRdsInstance(t, databaseInfo.ID, "us-east-1")
	port := aws.GetPortOfRdsInstance(t, databaseInfo.ID, "us-east-1")
	require.Contains(t, databaseInfo.ConnectionString, fmt.Sprintf("%s:%d/postgres", address, port))

	db, err := sql.Open("postgres", databaseInfo.ConnectionString)
	require.NoError(t, err)

	var version int
	require.NoError(t, db.QueryRow("SHOW server_version_num").Scan(&version))
	require.Equal(t, 120002, version)
}
