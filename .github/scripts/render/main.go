package main

import (
	"fmt"
	"os"
	"time"

	"github.com/nosenadayo/challenge_talana/render/check"
	"github.com/nosenadayo/challenge_talana/render/deploy"
)

func main() {
	// Debugging de variables de entorno
	fmt.Println("🔍 Verificando variables de entorno...")

	apiKey := os.Getenv("RENDER_API_KEY")
	serviceID := os.Getenv("RENDER_SERVICE_ID")

	if apiKey == "" || serviceID == "" {
		fmt.Println("❌ Error: RENDER_API_KEY y RENDER_SERVICE_ID son requeridos")
		os.Exit(1)
	}

	// Iniciar deploy
	deployID, err := deploy.InitiateDeploy(apiKey, serviceID)
	if err != nil {
		fmt.Printf("❌ Error iniciando deploy: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("🚀 Deploy iniciado con ID: %s\n", deployID)

	// Verificar estado del deploy
	checker := check.NewDeployChecker(apiKey, serviceID, deployID)

	if err := checker.WaitForDeploy(20 * time.Second); err != nil {
		fmt.Printf("❌ Error en el deploy: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("✅ Deploy completado exitosamente!")
}
