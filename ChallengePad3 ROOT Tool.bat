@echo off
cd /d %~dp0


echo 起動しました。


set "ADB_CMD=%~dp0Data\adb\adb.exe"
set "MTK_SU_FILE=%~dp0Data\mtk-su\mtk-su"


echo ファイル存在チェック


:: --------------------------------------------
:: 1. ADBファイルのチェック
:: --------------------------------------------
if not exist "%ADB_CMD%" (
    echo.
    echo [エラー] ADBファイルが見つかりません！
    echo 探している場所: "%ADB_CMD%"
    echo.
    echo フォルダ構成が正しいか確認してください。
    pause
    exit
)




:: --------------------------------------------
:: 2. 接続案内
:: --------------------------------------------
cls
echo ==========================================
echo  チャレパ3 Root化ツール (Portable)
echo ==========================================
echo.
echo [1/3] タブレットを接続してください...
echo.
echo  ★重要★
echo  画面が進まない場合は、タブレット側で
echo  「USBデバッグを許可」してください！
echo.


"%ADB_CMD%" wait-for-device

echo.
echo  -^> 接続を確認しました！

:: --------------------------------------------
:: 3. ファイル転送処理
:: --------------------------------------------
echo.
echo [2/3] Root化ファイル(mtk-su)の準備...
"%ADB_CMD%" shell ls /data/local/tmp/mtk-su >nul 2>&1

if not errorlevel 1 (
    echo  -^> 【スキップ】すでに準備完了しています。
) else (
    echo  -^> 【転送】ファイルを送信中...
    if not exist "%MTK_SU_FILE%" (
        echo [エラー] mtk-suファイルが見つかりません！
        echo 場所: "%MTK_SU_FILE%"
        pause
        exit
    )
    "%ADB_CMD%" push "%MTK_SU_FILE%" /data/local/tmp/
)

:: --------------------------------------------
:: 4. Rootシェル起動
:: --------------------------------------------
echo.
echo [3/3] Rootシェルを起動します！
echo ==========================================
echo  成功すると 'UID: 0...' と表示されます。
echo  終了するときは 'exit' と入力してエンターを押してください。
echo ==========================================
echo.

:: 権限付与
"%ADB_CMD%" shell chmod 755 /data/local/tmp/mtk-su

:: 対話モード起動
"%ADB_CMD%" shell -t "cd /data/local/tmp; ./mtk-su"

echo.
echo 終了しました。
pause