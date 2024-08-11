package main

import (
	"go-chat-app/config"
	"go-chat-app/routes"
)

func main() {
	config.ConnectDatabase()

	r := routes.SetupRouter()

	r.Run(":8080")
}
