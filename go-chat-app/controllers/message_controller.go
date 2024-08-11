package controllers

import (
	"go-chat-app/config"
	"go-chat-app/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func CreateMessage(c *gin.Context) {
	var message models.Message
	applicationToken := c.Param("application_token")
	chatIDStr := c.Param("chat_id")

	chatID, err := strconv.ParseUint(chatIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid chat ID"})
		return
	}

	var application models.Application
	if err := config.DB.Where("token = ?", applicationToken).First(&application).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Application not found"})
		return
	}

	var chat models.Chat
	if err := config.DB.Where("id = ? AND application_id = ?", uint(chatID), application.ID).First(&chat).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Chat not found for this application"})
		return
	}

	if err := c.BindJSON(&message); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON"})
		return
	}

	message.ChatID = chat.ID

	if err := config.DB.Create(&message).Error; err != nil {
		c.JSON(http.StatusUnprocessableEntity, gin.H{"error": err.Error()})
		return
	}

	config.DB.Model(&chat).Update("messages_count", chat.MessagesCount+1)

	c.JSON(http.StatusAccepted, gin.H{"message_number": message.Number})
}
