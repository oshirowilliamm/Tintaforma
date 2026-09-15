//desenhando as chaves
if (chaves > 0)
{
    var _x = 20;
    var _y = 10;
    var _texto = string("[scale, 5][{0}, 0][/] [scale, .8][txt_yellow]{1}[/]", spr_chave_ui, chaves);
    
    scribble(_texto)
        .starting_format("fnt_game", c_white)
        .draw(_x, _y);
}