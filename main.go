package main

import (
	"log"
	"os"
	"time"

	"gopkg.in/telebot.v3"
)

func main() {
	token := os.Getenv("TELE_TOKEN")
	if token == "" {
		log.Fatal("❌ TELE_TOKEN не встановлено!")
	}

	bot, err := telebot.NewBot(telebot.Settings{
		Token:  token,
		Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
	})
	if err != nil {
		log.Fatal("❌ Помилка створення бота:", err)
	}

	bot.Handle("/start", func(c telebot.Context) error {
		return c.Send("Привіт! Я твій перший бот! 🎉")
	})

	bot.Handle(telebot.OnText, func(c telebot.Context) error {
		return c.Send("Ти сказав: " + c.Text())
	})

	log.Println("🤖 Бот запускається...")
	bot.Start()
}