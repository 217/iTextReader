function HighlightText(keywords)
{
    var keywordArray = keywords.split(' ');
    var containerID = document.body;
    if (containerID)
    {
        var content = containerID.innerHTML;
        for (var i = 0; i<keywordArray.length; i++)
        {
            var re = new RegExp('('+keywordArray[i]+')','ig');
            content = content.replace(re,'<span class="search-highlight">$1<\/span>');
        }
        containerID.innerHTML = content;
    }
}