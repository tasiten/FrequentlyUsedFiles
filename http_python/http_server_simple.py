import http.server as s
import json

#########################################
# Webサーバ
class MyHandler(s.BaseHTTPRequestHandler):
    #---------------------------------------------------------------------
    def do_GET(self): # HTTPクライアントから GET されたときの処理
        msg="<HTTP><TITLE>TAKAGO LAB</TITLE><BODY><HR>...(o_o) TEST SERVER<HR></BODY></HTML>\n".encode("utf-8")    
        # ヘッダにメッセージを付けて返す
        self.send_response(200)
        self.send_header("Content-type", 'text/html')
        self.end_headers()
        self.wfile.write(msg)

    #---------------------------------------------------------------------
    def do_POST(self): # HTTPクライアントから POST されたときの処理

        # クライアントからのリクエストの取り出し
        content_len  = int(self.headers.get("content-length")) # ヘッダからデータ長を抜き出し
        recv_body = self.rfile.read(content_len).decode('utf-8') # メッセージ取り出し

        print(recv_body)
        send_body = "(*_*)/ " + recv_body + "\n"

        # クライアントにレスポンスを返す
        self.send_response(200)
        self.send_header('Content-type', 'application/json;charset=utf-8')
        self.end_headers()
        self.wfile.write(send_body.encode("utf-8")) # メッセージの送信


#########################################
# サーバ起動
httpd = s.HTTPServer(('0.0.0.0', 50000), MyHandler)
httpd.serve_forever()