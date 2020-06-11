import Config

config :world_temp, open_weather_map_api_key: System.fetch_env!("API_KEY")
