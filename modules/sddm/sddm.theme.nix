_:
let
  base = "#191724";
  surface = "#1f1d2e";
  text = "#1f1d2e";
in
{
  General = {
    passwordCharacter = "*";
    passwordMask = true;
    passwordInputWidth = "0.5";
    passwordInputBackground = surface;
    passwordInputRadius = "8";
    passwordInputCursorVisible = false;
    passwordFontSize = "96";
    passwordCursorColor = text;
    passwordTextColor = "";

    showSessionsByDefault = false;
    sessionsFontSize = "24";

    showUsersByDefault = false;
    usersFontSize = "48";

    background = "";
    backgroundFill = base;
    backgroundFillMode = "aspect";

    basicTextColor = text;

    blurRadius = "";
  };
}
