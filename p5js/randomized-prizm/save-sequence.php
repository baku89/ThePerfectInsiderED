<?
 header("Access-Control-Allow-Origin: *");

//canvasデータがPOSTで送信されてきた場合
$canvas = $_POST["image"];
$path = $_POST["path"];
 
//ヘッダに「data:image/png;base64,」が付いているので、それは外す
$canvas = preg_replace("/data:[^,]+,/i","",$canvas);
 
//残りのデータはbase64エンコードされているので、デコードする
$canvas = base64_decode($canvas);
 
//まだ文字列の状態なので、画像リソース化
$image = imagecreatefromstring($canvas);

$dir = dirname( $path );

if ( !file_exists( $dir ) ) {
    mkdir( $dir, 0777, true);
}

 
//画像として保存（ディレクトリは任意）
// imagesavealpha($image, false); // 透明色の有効
imagepng($image, $path );

?>