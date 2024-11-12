package check

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type DeployStatus struct {
	ID     string `json:"id"`
	Status string `json:"status"`
}

type DeployChecker struct {
	apiKey    string
	serviceID string
	deployID  string
	client    *http.Client
}

func NewDeployChecker(apiKey, serviceID, deployID string) *DeployChecker {
	return &DeployChecker{
		apiKey:    apiKey,
		serviceID: serviceID,
		deployID:  deployID,
		client:    &http.Client{Timeout: 10 * time.Second},
	}
}

func (c *DeployChecker) WaitForDeploy(checkInterval time.Duration) error {
	for {
		status, err := c.checkStatus()
		if err != nil {
			return fmt.Errorf("error verificando estado: %w", err)
		}

		fmt.Printf("Estado actual: %s\n", status)

		switch status {
		case "live":
			return nil
		case "build_failed":
			return fmt.Errorf("el deploy falló")
		default:
			fmt.Printf("⏳ Esperando %v antes de verificar nuevamente...\n", checkInterval)
			time.Sleep(checkInterval)
		}
	}
}

func (c *DeployChecker) checkStatus() (string, error) {
	url := fmt.Sprintf("https://api.render.com/v1/services/%s/deploys/%s",
		c.serviceID, c.deployID)

	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return "", fmt.Errorf("error creando request: %w", err)
	}

	req.Header.Set("Authorization", "Bearer "+c.apiKey)

	resp, err := c.client.Do(req)
	if err != nil {
		return "", fmt.Errorf("error en request: %w", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("error leyendo respuesta: %w", err)
	}

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("status code inesperado: %d, body: %s",
			resp.StatusCode, string(body))
	}

	var status DeployStatus
	if err := json.Unmarshal(body, &status); err != nil {
		return "", fmt.Errorf("error parseando JSON: %w, body: %s", err, string(body))
	}

	return status.Status, nil
}
