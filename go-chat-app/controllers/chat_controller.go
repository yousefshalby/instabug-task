package controllers

import (
	"go-chat-app/config"
	"go-chat-app/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreateChat(c *gin.Context) {
	var chat models.Chat
	applicationToken := c.Param("application_token")

	var application models.Application
	if err := config.DB.Where("token = ?", applicationToken).First(&application).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Application not found"})
		return
	}

	chat.ApplicationID = application.ID

	if err := config.DB.Create(&chat).Error; err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{"error": err.Error()})
		return
	}

	config.DB.Model(&application).Update("chats_count", application.ChatsCount+1)
	c.JSON(http.StatusCreated, chat)
}
