# ����Ƿ��Թ���ԱȨ������
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    # ��ȡ�ű�������·��
    $scriptPath = $MyInvocation.MyCommand.Definition
    # �����Թ���ԱȨ�������ű�
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}

# ·������Ϊ������Ҫ��ֹ������ʵĳ������ڵ��ļ���
$FolderPath = "C:\Program Files (x86)\360\360zip"

# ��ȡ���ļ��������е�.exe�ļ�
$Executables = Get-ChildItem -Path $FolderPath -Filter *.exe -Recurse

$taskName = "360"

# Ϊÿ��.exe�ļ���������ǽ����
foreach ($exe in $Executables) {
    $ruleNameOut = $taskName + "Block_Outbound_" + $exe.Name
    $ruleNameIn = $taskName + "Block_Inbound_" + $exe.Name

    # ��������ǽ�����ֹ�����վ����
    New-NetFirewallRule -DisplayName $ruleNameOut -Direction Outbound -Program $exe.FullName -Action Block
    # ��������ǽ�����ֹ������վ����
    New-NetFirewallRule -DisplayName $ruleNameIn -Direction Inbound -Program $exe.FullName -Action Block

    Write-Output "�Ѵ�����ֹ��վ����վ�Ĺ��򣬳���$exe.FullName"
}

Write-Output "���г���ĳ�վ����վ������������ɣ�����"
# �ȴ��û�����������˳�
Write-Output "��������˳�..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")