$MyPath = "LocationOfLocalReposToMerge"
$FolderNames = "Repo1","Repo2","Repo3","Repo4","Repo5"
$Processed = @()

git init
dir > deleteme.txt
git add .
git commit -m “Initial dummy commit”

foreach ($element in $FolderNames) 
{
    $name = $element -replace '\s',''
    $Processed += $element

    git remote add -f $name ($MyPath + $element)
    "ADDED REMOTE"
    git merge $name/master --allow-unrelated-histories
    "MERGED"

    if ($element -eq $FolderNames[0]) 
    {
        git rm .\deleteme.txt
        git commit -m “Clean up initial file”
    } 

    mkdir $element
    "DIR CREATED"
    dir –exclude $Processed | %{git mv $_.Name $element}
    "MOVE FILES COMPLETE"
    $CommitMsg = “Move " + $element + " files into subdir”
    git commit -m $CommitMsg
}

"COMPLETE"
