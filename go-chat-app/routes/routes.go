package routes

import (
	"go-chat-app/controllers"

	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.POST("/api/v1/applications/:application_token/chats", controllers.CreateChat)
	r.POST("/api/v1/applications/:application_token/chats/:chat_id/messages", controllers.CreateMessage)

	return r
}
