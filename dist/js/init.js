const app = Elm.Main.init({ node: document.getElementById("app") });
app.ports.print.subscribe(() => window.print());
app.ports.getWordFile.subscribe(() => {
  app.ports.updateWordFile.send(
    "data:application/vnd.ms-word;charset=utf-8," +
      encodeURIComponent(
        [
          '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">',
          "<head>",
          '<meta charset="utf-8">',
          "<title>Em nome da LAI!</title>",
          "</head>",
          "<body>",
          document.getElementById("document").innerHTML,
          "</body>",
          "</html>",
        ].join()
      )
  );
});
