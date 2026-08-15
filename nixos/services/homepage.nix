{ ... }:

{
  services.homepage-dashboard = {
    enable = true;
    listenPort = 7575; # Порт для Zen Browser

    # Настройки твоих 20+ сайтов (разбивай по группам)
    bookmarks = [
      {
        "Разработка и IT" = [
          {
            GitHub = {
              icon = "github.png";
              href = "https://github.com";
            };
          }
        ];
      }
      {
        "Нейросети" = [
          {
            ChatGPT = {
              icon = "chatgpt.png";
              href = "https://openai.com";
            };
          }
        ];
      }
    ];

    # Общие настройки интерфейса
    settings = {
      title = "Zen Dashboard";
      headerStyle = "clean"; # Минималистичный заголовок
      layout = {
        "Разработка и IT" = {
          style = "grid";
          columns = 4;
        };
        "Нейросети" = {
          style = "grid";
          columns = 4;
        };
      };
    };

    # Сюда можно выводить системные виджеты (время, погоду и т.д.)
    widgets = [
      {
        datetime = {
          format = {
            date = "long";
            time = "short";
            hour12 = false;
          };
        };
      }
    ];
  };
}
