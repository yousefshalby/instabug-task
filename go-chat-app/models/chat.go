package models

import (
	"time"

	"gorm.io/gorm"
)

type Chat struct {
	ID            uint `gorm:"primaryKey"`
	ApplicationID uint
	MessagesCount int `gorm:"default:0"`

	Number    int       `gorm:"uniqueIndex"`
	Messages  []Message `gorm:"foreignKey:ChatID"`
	CreatedAt time.Time `gorm:"autoCreateTime"`
	UpdatedAt time.Time `gorm:"autoUpdateTime"`
}

func (c *Chat) BeforeCreate(tx *gorm.DB) (err error) {
	var maxNumber int
	tx.Model(&Chat{}).Order("number desc").Limit(1).Select("number").Scan(&maxNumber)
	c.Number = maxNumber + 1
	return nil
}
