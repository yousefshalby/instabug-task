package models

type Application struct {
	ID         uint   `gorm:"primaryKey"`
	ChatsCount int    `gorm:"default:0"`
	Token      string `gorm:"unique;not null"`
	Chats      []Chat `gorm:"foreignKey:ApplicationID"`
}
