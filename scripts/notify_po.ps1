param()

$input_text = $input | Out-String

try {
    $input_data = $input_text | ConvertFrom-Json
    $file_path = $input_data.file_path
}
catch {
    exit 0
}

if ($file_path -like "*notifications.jsonl") {

    [System.Media.SystemSounds]::Exclamation.Play()

    try {
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime] | Out-Null

        $template = @"
<toast>
    <visual>
        <binding template="ToastText02">
            <text id="1">Workflow Update</text>
            <text id="2">Une instance Dev a termine sa tache !</text>
        </binding>
    </visual>
    <audio src="ms-winsoundevent:Notification.Default"/>
</toast>
"@

        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml($template)

        $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Claude Code Workflow").Show($toast)
    }
    catch {
        [console]::beep(800, 300)
        [console]::beep(1000, 300)
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $alerts_file = Join-Path (Split-Path $file_path -Parent) "po_alerts.log"
    $message = "$timestamp - Une instance Dev a termine. Verifiez notifications.jsonl"

    try {
        Add-Content -Path $alerts_file -Value $message -ErrorAction SilentlyContinue
    }
    catch {
    }
}

exit 0
