_: {
  exec = "printf \" $(ollama ps | tail -n +2 | wc -l) Running\n$(ollama ps | tail -n +2 | awk '{print $1 \" \" $3 $4}')\"";
  interval = 5;
}
