
#!/usr/bin/php
<?php
//error_reporting(E_ALL & ~E_NOTICE);
function check_colonne($ligne, $num, $header)
{
if (strlen($ligne) > 81)
{
$nb = strlen($ligne) - 80 - 1;
disp_ligne($num + 1 - $header);
echo "Plus de 80 colonnes, ".$nb." caractere(s) en trop!\n";
$tab[0] = 1;
$tab[1] = $nb;
}
if (isset($tab))
return ($tab);
else
return (0);
}

function traitement_regex($tab, $index, $cor, $header)
{
$k = 0;
$tab_reg[$k]["reg"] = "([[:blank:]]{1,})[\n]$";
$tab_reg[$k]["msg"] = "Espace(s) en fin de ligne!\t";
$tab_reg[$k]["err"] = 1; 
$tab_reg_bis[$k]["reg"] = "([[:blank:]]{1,})[\n]$";
$tab_reg_bis[$k]["rep"] = "\n";

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]if\(";
$tab_reg[$k]["msg"] = "Il manque un espace apres if!\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "if\(";
$tab_reg_bis[$k]["rep"] = "if (";

$k++;
$tab_reg[$k]["reg"] = "if([[:blank:]]{2,})\(";
$tab_reg[$k]["msg"] = "Il y a trop d'espaces apres if!\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "if([[:blank:]]{2,})\(";
$tab_reg_bis[$k]["rep"] = "if ("; 

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]while\(";
$tab_reg[$k]["msg"] = "Il manque un espace apres while!";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "while\(";
$tab_reg_bis[$k]["rep"] = "while ("; 

$k++;
$tab_reg[$k]["reg"] = "while([[:blank:]]{2,})\(";
$tab_reg[$k]["msg"] = "Il y a trop d'espaces apres while!";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "while([[:blank:]]{2,})\(";
$tab_reg_bis[$k]["rep"] = "while ("; 

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]return\(";
$tab_reg[$k]["msg"] = "Il manque un espace apres return!";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "return\(";
$tab_reg_bis[$k]["rep"] = "return ("; 

$k++;
$tab_reg[$k]["reg"] = "return([[:blank:]]{2,})\(";
$tab_reg[$k]["msg"] = "Il y a trop d'espaces apres return!";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "return([[:blank:]]{2,})\(";
$tab_reg_bis[$k]["rep"] = "return ("; 

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]switch[[:blank:]]";
$tab_reg[$k]["msg"] = "Switch, c'est interdit mon coco!";
$tab_reg[$k]["err"] = 20;
$tab_reg_bis[$k]["reg"] = NULL;
$tab_reg_bis[$k]["rep"] = NULL;

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]for[[:blank:]]";
$tab_reg[$k]["msg"] = "For, c'est interdit mon coco!";
$tab_reg[$k]["err"] = 20;
$tab_reg_bis[$k]["reg"] = NULL;
$tab_reg_bis[$k]["rep"] = NULL;

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]elseif[[:blank:]]";
$tab_reg[$k]["msg"] = "Elseif, c'est interdit mon coco!";
$tab_reg[$k]["err"] = 20;
$tab_reg[$k]["rep"] = NULL;

$k++;
$tab_reg[$k]["reg"] = "([[:blank:]]+);";
$tab_reg[$k]["msg"] = "Espace(s) avant le \";\"!\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "([[:blank:]]+);";
$tab_reg_bis[$k]["rep"] = ";";

$k++;
$tab_reg[$k]["reg"] = "[[:blank:]]\)";
$tab_reg[$k]["msg"] = "Espace(s) avant \")\"!\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "[[:blank:]]\)";;
$tab_reg_bis[$k]["rep"] = ")";

$k++;
$tab_reg[$k]["reg"] = "\([[:blank:]]";
$tab_reg[$k]["msg"] = "Espace(s) apres \"(\"!\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "\([[:blank:]]";
$tab_reg_bis[$k]["rep"] = "(";

$fautes = 0;
$points = 0;
for ($i = 0; $i <= $k; $i++)
{
if (ereg($tab_reg[$i]["reg"], $tab[$index]))
{
$fautes++;
$points += $tab_reg[$i]["err"];
disp_ligne($index - $header + 1);
echo $tab_reg[$i]["msg"];
if ($cor == 1 && $tab_reg_bis[$i]["reg"] != NULL)
{
$tab[$index] = ereg_replace($tab_reg_bis[$i]["reg"], $tab_reg_bis[$i]["rep"], $tab[$index]);
echo "\t\t\t... Done";
}
echo "\n";
}
}
$retour[0] = $fautes;
$retour[1] = $points;
$retour[2] = $tab;
return ($retour);
}

function check_header($tab, $name_file, $cor) // modif_tab_ok reste mise en forme header
{
$var = 0;
$fautes = 0;
$points = 0;
$header = 0;
if ($tab[0][0] == "/" && $tab[0][1] == "*")
$header = 1;
if ($tab[8][0] == "*" && $tab[8][1] == "/" && $header == 1)
$header = 2;
if ($header == 1)
{
$fautes++;
$points += 20;
echo "-> ATTENTION, le header est inccorecte!\n";
}
elseif ($header == 0)
{
$fautes++;
$points += 20;
echo "-> ATTENTION, il n'y a pas de header!";
if ($cor == 1)
{
$name = $_ENV["HOME"]."/.myemacs";
if (@file_exists($name))
{
$tableau = file($name);
for ($i = 0; $tableau[$i]; $i++)
{
if (ereg("user-full-name", $tableau[$i]))
{
$full_name = ereg_replace("(.*)user-full-name \"", "", $tableau[$i]);
$full_name = strtolower(ereg_replace("\")(.*)", "", $full_name));
}
if (ereg("user-mail-address", $tableau[$i]))
{
$mail = ereg_replace("(.*)user-mail-address \"", "", $tableau[$i]);
$mail = strtolower(ereg_replace("\")(.*)", "", $mail));
}
}
}
$tab_bis[0] = "/* \n";
$tab_bis[1] = "** ".$name_file." for ".$name_file." in ".getcwd()."\n";
$tab_bis[2] = "** \n";
$tab_bis[3] = "** Made by ".$full_name."\n";
$tab_bis[4] = "** Login <".$mail.">\n";
$tab_bis[5] = "** \n";
$date = date(" D M d H:i:s Y ");
$tab_bis[6] = "** Started on ".$date.$full_name."\n";
$tab_bis[7] = "** Last"." update".$date.$full_name."\n";
$tab_bis[8] = "*/ \n\n";
for ($i = 0; $tab[$i]; $i++)
{
$tab_bis[$i + 9] = $tab[$i]; 
}
$tab = $tab_bis;
echo "\t\t\t\t\t... Done";
$var = 9;
}
echo "\n";
}

$retour[0] = $fautes;
$retour[1] = $points;
$retour[2] = $tab;
$retour[3] = $var;
return ($retour);
}

function disp_ligne($num)
{
echo "--> Ligne ";
if ($num < 10)
echo " ";
if ($num < 100)
echo " ";
echo $num;
echo " : ";
}

function check_includ($tab, $header, $cor) // modif_tab_ok
{
$k = 0;
$tab_reg[$k]["reg"] = "#include\"";
$tab_reg[$k]["msg"] = "Il faut un espace apres #include!\t\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "#include\"";
$tab_reg_bis[$k]["rep"] = "#include \"";

$k++;
$tab_reg[$k]["reg"] = "#include<";
$tab_reg[$k]["msg"] = "Il faut un espace apres #include!\t\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "#include<";
$tab_reg_bis[$k]["rep"] = "#include <";

$k++;
$tab_reg[$k]["reg"] = "#include([[:blank:]]{2,})\"";
$tab_reg[$k]["msg"] = "Il y a trop d'espace apres #include!\t\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "#include([[:blank:]]{2,})\"";
$tab_reg_bis[$k]["rep"] = "#include \"";

$k++;
$tab_reg[$k]["reg"] = "#include([[:blank:]]{2,})<";
$tab_reg[$k]["msg"] = "Il y a trop d'espace apres #include!\t\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "#include([[:blank:]]{2,})<";
$tab_reg_bis[$k]["rep"] = "#include <";

$k++;
$tab_reg[$k]["reg"] = "([[:blank:]]{1,})\n";
$tab_reg[$k]["msg"] = "Espace(s) en fin de ligne!\t\t\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "([[:blank:]]{1,})\n";
$tab_reg_bis[$k]["rep"] = "\n";

$k++;
$tab_reg[$k]["reg"] = "#define([[:blank:]]{2,})";
$tab_reg[$k]["msg"] = "Il y a trop d'espace apres #define!\t\t\t";
$tab_reg[$k]["err"] = 1;
$tab_reg_bis[$k]["reg"] = "#define([[:blank:]]{2,})";
$tab_reg_bis[$k]["rep"] = "#define ";


$fautes = 0;
$points = 0;
for ($i = 0; $tab[$i]; $i++)
{
if (ereg("#include", $tab[$i]) || ereg("#define", $tab[$i]))
{
for ($j = 0; $j <= $k; $j++)
{
if (ereg($tab_reg[$j]["reg"], $tab[$i]))
{
disp_ligne($i - $header + 1);
echo $tab_reg[$j]["msg"];
if ($cor == 1)
{
$tab[$i] = ereg_replace($tab_reg_bis[$j]["reg"], $tab_reg_bis[$j]["rep"], $tab[$i]);
$faute++;
$point += $tab_reg[$j]["err"]; 
echo "... Done";
}
echo "\n";
}
}

$include_bis = $include;
$include = 0;
if (ereg("<", $tab[$i]))
$include = 1;
if (ereg("\"", $tab[$i]))
$include = 2;
if ($include_bis == 2 && $include == 1)
{
disp_ligne($i - $header + 1);
echo "Mauvais placement #include <...> / #include \"...\"!\n";
} 
}
}
$retour[0] = $fautes;
$retour[1] = $fautes;
$retour[2] = $tab;
return ($retour);
}

function recup_index($tab)
{
$k = 0;
for ($i = 0; $tab[$i]; $i++)
{
if ($tab[$i][0] == '{')
$index[$k]["deb"] = $i - 1;
if ($tab[$i][0] == '}')
$index[$k++]["fin"] = $i;
}
return ($index);
}

function check_declaration($tab, $index, $cor, $header) // modif_tab_ok
{
$fautes = 0;
$points = 0;
$str = $tab[$index];
$str = ereg_replace("\((.*)", "", $str);
$pos = strpos($str, " ");
if ($pos != NULL)
{
disp_ligne($index - $header + 1);
echo "Mauvaise declaration, espace au lieu de tabulation!";
if ($cor == 1)
{
$str = $tab[$index];
$str1 = ereg_replace("(.*)[[:blank:]]", "", $str);
$str2 = ereg_replace("[[:blank:]](.*)", "", $str);
$str = $str2."\t".$str1;
$tab[$index] = $str;
echo "\t... Done";
}
$points++;
$fautes++;
echo "\n";
}
$retour[0] = $fautes;
$retour[1] = $points;
$retour[2] = $tab;
return ($retour);
}

function check_function($tab, $deb, $fin, $cor, $header)
{
$points = 0;
$fautes = 0;
$nb = $fin - $deb - 2;
if ($nb > 25)
{
$fautes++;
$points += ($nb - 25);
$str = $tab[$deb];
$str = ereg_replace("\((.*)", "", $str);
$str = ereg_replace("(.*)[ ]", "", $str);
$str = ereg_replace("(.*)[[:blank:]]", "", $str);
disp_ligne($deb + 1);
echo "La fonction ".$str." comporte ".$nb." lignes\n";
}
$pos_beg = strpos($tab[$deb], "(");
$pos_end = strrpos($tab[$deb], ")");
$str = substr($tab[$deb], $pos_beg + 1, ($pos_end - $pos_beg - 1));
if (strlen($str) == 0)
{
disp_ligne($deb + 1);
echo "Fonction sans parametre : (void)!";
if ($cor == 1)
{
$str = $tab[$deb];
$str1 = ereg_replace("(.*)\(", "", $str);
$str2 = ereg_replace("\)(.*)", "", $str);
$str = $str2."void".$str1;
$tab[$deb] = $str;
echo "\t\t\t... Done";
}
echo "\n";
}
/* $retour = check_declaration($tab, $deb, $cor, $header);
$fautes += $retour[0];
$points += $retour[1];
$tab = $retour[2];*/
for ($i = $deb + 2; $i < $fin; $i++)
{
$retour = check_colonne($tab[$i], $i, $header);
$fautes += $retour[0];
$points += $retour[1];
$retour = traitement_regex($tab, $i, $cor, $header);
$fautes += $retour[0];
$points += $retour[1];
$tab = $retour[2];
}
$retour[0] = $fautes;
$retour[1] = $points;
$retour[2] = $tab;
return ($retour);
}

function verif_code($tab, $cor, $file_name)
{
$fautes = 0;
$points = 0;
$retour = check_header($tab, $file_name, $cor);
$fautes += $retour[0];
$points += $retour[1];
$tab = $retour[2];
$header = $retour[3];
$index = recup_index($tab);
$count = 0;
for ($i = 0; isset($index[$i]["deb"]); $i++)
$count++;
if ($count > 5)
{
$points += 20 * ($count - 5);
$fautes++;
echo "-> ATTENTION, il y a plus de 5 fonctions!\n";
}
$retour = check_includ($tab, $header, $cor);
$fautes += $retour[0];
$points += $retour[1];
$tab = $retour[2];
for ($i = 0; isset($index[$i]["deb"]); $i++)
{
$retour = check_function($tab, $index[$i]["deb"], $index[$i]["fin"], $cor, $header);
$fautes += $retour[0];
$points += $retour[1];
$tab = $retour[2];
}
echo "\nIl y a ".$fautes." fautes de norme (-".$points.").\n";
return ($tab);
}
echo "------------------------------------------\n";
echo "| |\n";
echo "| --== Norme (1.1) ==-- |\n";
echo "|  ** \n"; 
echo "| |\n";

if($argc > 1)
{
echo "------------------------------------------\n";
$cor = 0;
$save = 0;
for($i = 1; $i < $argc; $i++)
{
if (strcmp($argv[$i], "-correct") == 0)
$cor = 1;
if (strcmp($argv[$i], "-save") == 0)
$save = 1;
}
for($file = 1; $file < $argc; $file++)
{
if(@file_exists($argv[$file]) && !is_dir($argv[$file]))
{
echo "Traitement du fichier : ".$argv[$file]."\n";
$i = 0;
$lines = file($argv[$file]);
$tab = NULL;
foreach ($lines as $lines_num => $line)
{
$tab[$i++] = $line;
}
$tab[$i] = NULL;
$tab = verif_code($tab, $cor, $argv[$file]);
if ($cor == 1)
{
if (file_exists(getcwd()."/save") == FALSE && $save == 1)
mkdir(getcwd()."/save");
if ($save == 1)
copy($argv[$file], getcwd()."/save/save_".date("Y_m_d_H_i_s")."_".$argv[$file]);
$fd = fopen($argv[$file], "w");
if ($fd != NULL)
{
for ($i = 0; $tab[$i]; $i++)
fwrite($fd, $tab[$i]);
}
fclose($fd);
}
echo "\n";
}
}
}
else
{
echo "| Utilisation : |\n";
echo "| ./norme fichier_1, ficher_2 ... |\n";
echo "| |\n";
echo "| Correction automatique : |\n";
echo "| ./norme -correct fichier_1 ... |\n";
echo "| |\n";
echo "| Sauvegarde : (dans save/) |\n";
echo "| ./norme -correct -save fichier_1 ... |\n";
echo "| |\n";
echo "| Detections : |\n";
echo "| - depassement des 80 colonnes |\n";
echo "| - depassement des 25 lignes |\n";
echo "| - depassement de 5 fonctions |\n";
echo "| - mot interdit (for, switch, elseif) |\n";
echo "| - espace apres (return, if, while) |\n";
echo "| - pas de header, ou header incorrecte |\n";
echo "| - espace(s) en fin de ligne |\n";
echo "| - espace(s) avant le ';' |\n";
echo "| - #include <...> avant #include \"...\" |\n";
echo "| - espace(s) apres #include et #define |\n";
echo "| - declaration des fonctions |\n";
echo "| - fonction sans parametres (void) |\n";
echo "| - presence du header |\n";
echo "| - espace(s) apres '(' |\n";
echo "| - espace(s) avant ')' |\n";
echo "| |\n";
echo "| Un conseil : rm la V1.0 !! |\n";
echo "| |\n";
echo "| --== V 2.0 en cours ==-- |\n";
echo "| |\n";
echo "| Si vous avez des idees d'amelioration |\n";
echo "| ou detectez des bugs, n'hesitez pas ! |\n";
echo "------------------------------------------\n";
}
?>
