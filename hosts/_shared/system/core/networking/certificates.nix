let
  _ = builtins;
  ls = root: (_.map (f: root + "/${f}") (_.attrNames (_.readDir root)));
in
{
  security.pki.certificateFiles = ls ./certificates;
}
