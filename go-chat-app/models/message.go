package models

import (
	"time"

	"gorm.io/gorm"
)

type Message struct {
	ID        uint `gorm:"primaryKey"`
	ChatID    uint
	Body      string
	Number    int       `gorm:"uniqueIndex"`
	CreatedAt time.Time `gorm:"autoCreateTime"`
	UpdatedAt time.Time `gorm:"autoUpdateTime"`
}

func (c *Message) BeforeCreate(tx *gorm.DB) (err error) {
	var maxNumber int
	tx.Model(&Message{}).Order("number desc").Limit(1).Select("number").Scan(&maxNumber)
	c.Number = maxNumber + 1
	return nil
}
