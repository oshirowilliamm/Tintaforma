function screenshake(_shake)
{
    if (!instance_exists(obj_screenshake)) exit;
    
    with (obj_screenshake) 
    {
        if (_shake > shake)
        {
            shake = _shake;
        }
    }
}