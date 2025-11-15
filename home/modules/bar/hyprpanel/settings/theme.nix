{ config, ... }:
{
  font = {
    name = config.my.font-family;
    label = config.my.font-family;
    size = "1rem";
  };
  bar = {
    floating = false;
    margin_top = "0";
    margin_sides = "0";
    margin_bottom = "0";
  };
}
