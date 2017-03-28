rm Alias:cd chdir
set-alias np "C:\Program Files (x86)\Notepad++\Notepad++.exe"
set-alias emacs "D:\app\emacs\bin\runemacs.exe"
set-alias editor np
function cd
{
    $ES = ".\es.exe";
    if (!(Test-Path (Resolve-Path $ES).Path)){
        Write-Warning "Everything commandline es.exe could not be found on the system please download and install via http://www.voidtools.com/es.zip"
        exit
    }

    $search = [system.string]::Join(' ', $args);
    if($search -eq "")
    {
        & (Resolve-Path $ES).Path --help
        return;
    }
	
	$result =  [System.Collections.ArrayList]@()
	
	if($args.Length -gt 1 -and $args[0] -eq ".")
	{
	    $dirs = Get-ChildItem -Directory

		foreach($dir in $dirs)
		{
			if($dir.Name.ToLower().IndexOf($args[1].ToLower()) -ge 0)
			{
				$result.Add($dir.FullName) | Out-Null
			}
		}
	}
	else
	{
		$path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($search)
		if([System.IO.Directory]::Exists($path))
		{
			Set-Clipboard $path
			pushd $path
			return;
		}

		$result = & (Resolve-Path $ES).Path $args
		if($result.Count -lt 1){
			Write-Host -ForegroundColor Red "Not found the directory: $search";
			return;
		}
	}

    if($result.Count -eq 1)
    {
        $record = $result;
        if([System.IO.Directory]::Exists($result)){
            Set-Clipboard $result
            pushd $result
        }
    }
    else
    {
        $newArray =  [System.Collections.ArrayList]@()
        $i = 0;
        foreach($dir in $result)
        {
            if([System.IO.Directory]::Exists($dir)){
                Write-Host "[ $i ] "  $dir
                $i++;
                $newArray.Add($dir) | Out-Null
            }
        }

        while($true)
        {
            $arrlen = $newArray.Count - 1;
            if($arrlen -eq 0)
            {
                Set-Clipboard $newArray[0]
				pushd $newArray[0]
                break;
            }

            $flag = $true
            $userInput = Read-host "Choose the above folder to fast jump [0 - $arrlen] / [Filter]"
			if($userInput -eq "")
			{
                Set-Clipboard $newArray[0]
				pushd $newArray[0]
                break;
			}
			
            try
            {
                [int]$inputNum = [convert]::ToInt32($userInput, 10)
            }
            catch
            {
                $flag = $false;
            }
                
            if($flag -and $inputNum -ge 0 -and $inputNum -le $arrlen)
            {
                Set-Clipboard $newArray[$inputNum]
				pushd $newArray[$inputNum]
                break;
            }
            else
            {
                $keys = $userInput.ToLower() -split ' '

                for($i = $arrlen; $i -ge 0; $i--)
                {
                    $del = $false
                    foreach($key in $keys)
                    {
                        if($key -eq "")
                        {
                            continue;
                        }
                    
                        if($newArray[$i].ToLower().IndexOf($key) -lt 0)
                        {
                            $del = $true;
                            break;
                        }
                    }

                    if($del)
                    {
                        $newArray.RemoveAt($i)
                    }
                }

                if($newArray -gt 0)
                {
                    $i = 0;
                    foreach($dir in $newArray)
                    {
                        Write-Host "[ $i ] "  $dir
                        $i++;
                    }
                }
                else
                {
                    Write-Host "No results after filter!!!";
                    break;
                }
            }
        }
    }
}



function ff
{
    $ES = ".\es.exe";
    if (!(Test-Path (Resolve-Path $ES).Path)){
        Write-Warning "Everything commandline es.exe could not be found on the system please download and install via http://www.voidtools.com/es.zip"
        exit
    }
	
    $search = [system.string]::Join(' ', $args);
    if($search -eq "")
    {
        & (Resolve-Path $ES).Path --help
        return
    }
	
	$result =  [System.Collections.ArrayList]@()
	
	if($args.Length -gt 1 -and $args[0] -eq ".")
	{
	    $files = Get-ChildItem -File

		foreach($file in $files)
		{
			if($file.Name.ToLower().IndexOf($args[1].ToLower()) -ge 0)
			{
				$result.Add($file.FullName) | Out-Null
			}
		}
	}
	else
	{
		$path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($search)
		if([System.IO.File]::Exists($path))
		{
			 Set-Clipboard $path
			 editor $path
			 return;
		}

		$result = & (Resolve-Path $ES).Path $args
		if($result.Count -lt 1){
			Write-Host -ForegroundColor Red "Not found the file: $search";
			return;
		}
	}

    if($result.Count -eq 1)
    {
        if([System.IO.File]::Exists($result)){
            Set-Clipboard $result
            editor $result
            return;
        }
    }
    else
    {
        $newArray =  [System.Collections.ArrayList]@()
        $i = 0;
        foreach($file in $result)
        {
            if([System.IO.File]::Exists($file)){
                Write-Host "[ $i ] "  $file
                $i++;
                $newArray.Add($file) | Out-Null
            }
        }

        while($true)
        {
            $arrlen = $newArray.Count - 1;
            if($arrlen -eq 0)
            {
                editor $newArray[0]
                break;
            }

            $flag = $true
            $userInput = Read-host "Choose the above file to fast open with editor [0 - $arrlen] / [Filter]"
			if($userInput -eq "")
			{
				editor $newArray[0]
                break;
			}
			
            try
            {
                [int]$inputNum = [convert]::ToInt32($userInput, 10)
            }
            catch
            {
                $flag = $false;
            }
                
            if($flag -and $inputNum -ge 0 -and $inputNum -le $arrlen)
            {
                editor $newArray[$inputNum]
                break;
            }
            else
            {
                $keys = $userInput.ToLower() -split ' '

                for($i = $arrlen; $i -ge 0; $i--)
                {
                    $del = $false
                    foreach($key in $keys)
                    {
                        if($key -eq "")
                        {
                            continue;
                        }
                    
                        if($newArray[$i].ToLower().IndexOf($key) -lt 0)
                        {
                            $del = $true;
                            break;
                        }
                    }

                    if($del)
                    {
                        $newArray.RemoveAt($i)
                    }
                }

                if($newArray -gt 0)
                {
                    $i = 0;
                    foreach($file in $newArray)
                    {
                        Write-Host "[ $i ] "  $file
                        $i++;
                    }
                }
                else
                {
                    Write-Host "No results after filter!!!";
                    break;
                }
            }
        }
    }
}

