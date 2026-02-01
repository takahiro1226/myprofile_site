職務経歴書のWEBページ版です。

URL
https://takahiro-work.click/

使用技術
html
css
AWS
-S3
-Cloudfront
-ACM
-Route53
Terraform
Github Action

AWS構成図


<img width="563" height="1050" alt="Image" src="https://github.com/user-attachments/assets/62c12b1f-8b30-4fa6-b157-0327a8da1832" />

Github Action

developプランチにpushした時、terraform planが動作します。

terraform plan後問題がなかったらmainブランチとmergeを手動で行い、

terraform applyとコンテンツ用のhtmlファイル等が更新されます。


テスト

・サイトにcloudfront経由でアクセスできること

1回目　独自のアドレスでアクセスできるか確認

curl -I https://takahiro-work.click

HTTP/2 200 

content-type: text/html

content-length: 29052

date: Sun, 01 Feb 2026 16:36:32 GMT

last-modified: Sun, 01 Feb 2026 16:11:43 GMT

etag: "36d942fab572adeb9fdeb4843588d889"

x-amz-server-side-encryption: AES256

x-amz-version-id: IVCnHyb_YPkzylezaMuDqyebH_WtHdOd

accept-ranges: bytes

server: AmazonS3

x-cache: Miss from cloudfront

via: 1.1 d8338baaff9bb8776297aeb3e7fc1f28.cloudfront.net (CloudFront)

x-amz-cf-pop: NRT57-P8

x-amz-cf-id: 5jknwyycOzlIv_jyjCcMSRqvB8ek2tebLIaFpODrz69pYJGD1tBnyQ==



2回目　キャッシュから配信されていることを確認
curl -I https://takahiro-work.click | grep x-cache

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed                               
  0 29052    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  
x-cache: Hit from cloudfront



3回目　CloudFront URLでのアクセス
curl -I https://d15pmtgxdohwi9.cloudfront.net

HTTP/2 200 

content-type: text/html

content-length: 29052

date: Sun, 01 Feb 2026 16:36:32 GMT

last-modified: Sun, 01 Feb 2026 16:11:43 GMT

etag: "36d942fab572adeb9fdeb4843588d889"

x-amz-server-side-encryption: AES256

x-amz-version-id: IVCnHyb_YPkzylezaMuDqyebH_WtHdOd

accept-ranges: bytes

server: AmazonS3

x-cache: Hit from cloudfront

via: 1.1 f3936b0ccad22aa012ab588e8896e33a.cloudfront.net (CloudFront)

x-amz-cf-pop: NRT57-P8

x-amz-cf-id: b-xBlEP0Obd1aY3b8RGeELVzRyl92BJPqdXSGFp5YiCDy-_b78WLmA==

age: 29




・S3への直接アクセスができないこと
curl -I https://myprofile-content-f7749b16.s3.ap-northeast-1.amazonaws.com/index.html

HTTP/1.1 403 Forbidden

x-amz-request-id: 4VWXA0B50KC9CBMS

x-amz-id-2: ZuSa5nMwHVB0ArZXGJCNTXtLR2eCtoR8z+rTNTV2921KciJAOESkttd4QczYRLjxcD34TuLaGdk=

Content-Type: application/xml

Transfer-Encoding: chunked

Date: Sun, 01 Feb 2026 16:42:09 GMT

Server: AmazonS3
