import cv2

def record_video(camera_index=0, output_filename="output.mp4", duration=10):
    # カメラを初期化
    cap = cv2.VideoCapture(camera_index)
    
    # カメラが正しく開かれなかった場合
    if not cap.isOpened():
        print(f"Error: Camera with index {camera_index} could not be opened.")
        return

    # 動画のプロパティを設定
    frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fps = int(cap.get(cv2.CAP_PROP_FPS)) or 30  # カメラがFPSを返さない場合、デフォルトで30FPSを使用

    # 動画の書き込みオブジェクトを作成 (MP4形式)
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    out = cv2.VideoWriter(output_filename, fourcc, fps, (frame_width, frame_height))

    # 録画開始
    print("Recording...")
    frame_count = 0
    total_frames = duration * fps

    while frame_count < total_frames:
        ret, frame = cap.read()
        if not ret:
            print("Error: Unable to capture video frame.")
            break
        
        # 動画を書き込み
        out.write(frame)
        frame_count += 1

    # リソースを解放
    cap.release()
    out.release()
    print(f"Video saved as {output_filename}")

# 使用例
record_video(camera_index=0, output_filename="recorded_video.mp4", duration=10)

