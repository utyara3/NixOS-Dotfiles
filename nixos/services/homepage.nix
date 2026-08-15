{ config, pkgs, ... }:

{

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082; # Порт, на котором будет крутиться страница

    # Настройки самой страницы (имя, иконки, поиск)
    settings = {
      title = "Мой Zen Dashboard";
      favicon = "https://zen-browser.app";
      layout = {
        "Инструменты" = {
          style = "grid";
          columns = 4;
        };
        "Мониторинг" = {
          style = "grid";
          columns = 3;
        };
      };
      search = {
        provider = "duckduckgo";
        target = "_blank";
      };
    };

    # Интеграция закладок и крутых виджетов-приблуд
    services = [
      {
        "Инструменты" = [
          {
            "Закладки Zen" = {
              icon = "zen-browser.app";
              href = "about:welcome";
              description = "Стартовая страница браузера";
            };
          }
          {
            "GitHub" = {
              icon = "github";
              href = "https://github.com";
              description = "Мой код";
            };
          }
        ];
      }
      {
        "Мониторинг" = [
          # Виджет погоды
          {
            "Погода" = {
              widget = {
                type = "weather";
                provider = "open-meteo";
                latitude = "55.7558"; # Укажите свои координаты
                longitude = "37.6173";
                units = "metric";
              };
            };
          }
        ];
      }
    ];

    # Мощные встроенные виджеты системы (API NixOS)
    widgets = [
      {
        logo = {
          icon = "nixos";
        };
      }
      {
        resources = {
          cpu = true;
          disk = "/";
          memory = true;
        };
      }
      {
        datetime = {
          text_size = "xl";
          format = {
            timeStyle = "short";
            dateStyle = "long";
          };
        };
      }
    ];
  };

}
