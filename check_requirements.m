function check_requirements()


assert( ~isempty(which('PsychtoolboxRoot')), '"PsychtoolboxRoot" not found : check Psychtooblox installation => http://psychtoolbox.org/' )
assert( ~isempty(which('StimTemplateContent')), '"StimTemplateContent" not found : check StimTemplate installation => https://github.com/benoitberanger/StimTemplate' )

end % function
