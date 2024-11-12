package deploy

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type DeployResponse struct {
	ID     string `json:"id"`
	Status string `json:"status"`
}

type RenderClient struct {
	httpClient *http.Client
	apiKey     string
}

func NewRenderClient(apiKey string) *RenderClient {
	return &RenderClient{
		httpClient: &http.Client{
			Timeout: 30 * time.Second,
		},
		apiKey: apiKey,
	}
}

func InitiateDeploy(apiKey, serviceID string) (string, error) {
	client := NewRenderClient(apiKey)
	return client.createDeploy(serviceID)
}

func (c *RenderClient) createDeploy(serviceID string) (string, error) {
	url := fmt.Sprintf("https://api.render.com/v1/services/%s/deploys", serviceID)

	req, err := http.NewRequest("POST", url, bytes.NewBuffer([]byte{}))
	if err != nil {
		return "", fmt.Errorf("error creando request: %w", err)
	}

	req.Header.Set("Authorization", "Bearer "+c.apiKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("error en request: %w", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("error leyendo respuesta: %w", err)
	}

	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusCreated {
		return "", fmt.Errorf("status code inesperado: %d, body: %s", resp.StatusCode, string(body))
	}

	var deployResp DeployResponse
	if err := json.Unmarshal(body, &deployResp); err != nil {
		return "", fmt.Errorf("error parseando JSON: %w, body: %s", err, string(body))
	}

	if deployResp.ID == "" {
		return "", fmt.Errorf("ID de deploy vacío en respuesta: %s", string(body))
	}

	return deployResp.ID, nil
}
