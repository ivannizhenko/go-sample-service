// main.go

package main

import (
	"os"

	"github.com/joho/godotenv"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"

	"go-sample-service/app"
)

func init() {
	LoadEnv()
}

func main() {
	a := app.App{}

	a.Initialize(
		os.Getenv("POSTGRES_HOST"),
		os.Getenv("POSTGRES_USER"),
		os.Getenv("POSTGRES_PASSWORD"),
		os.Getenv("POSTGRES_DB"))

	var (
		env  = os.Getenv("ENV")
		port = os.Getenv("PORT")
	)

	log.Info().Str("env", env).Str("port", port).Msg("loaded .env file")

	a.Run("0.0.0.0:" + port)
}

func LoadEnv() {
	// load .env file
	err := godotenv.Load(".env")
	if err != nil {
		log.Panic().Msg("Failed to load .env file. Stopping.")
	}

	SetGlobalLogger()
}

func SetGlobalLogger() {

	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stderr})

	logLevelStr := os.Getenv("LOG_LEVEL")
	if logLevelStr == "" {
		logLevelStr = "info"
	}

	logLevel, err := zerolog.ParseLevel(logLevelStr)
	if err != nil {
		log.Panic().Msgf("Failed to parse log level from environment variable")
	}

	zerolog.SetGlobalLevel(logLevel)
}
