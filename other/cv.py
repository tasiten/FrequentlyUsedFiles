# python3 cv.py /dev/video0
#

import cv2
import sys
import time
import os
 
os.environ["OPENCV_FFMPEG_CAPTURE_OPTIONS"] = "fflags;nobuffer | flag;low_delay | protocol_whitelist;file,rtp,udp"
 
# cap = cv2.VideoCapture(camno)
cap = cv2.VideoCapture(sys.argv[1])
print( cap.get(cv2.CAP_PROP_FPS) )
print( cap.get(cv2.CAP_PROP_FRAME_WIDTH) )
print( cap.get(cv2.CAP_PROP_FRAME_HEIGHT) )
print( cap.get(cv2.CAP_PROP_FRAME_COUNT) ) 

# fmt='YUYV'
# cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc(*fmt))
# cap.set(cv2.CAP_PROP_FRAME_WIDTH, 160)
# cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 120)
# cap.set(cv2.CAP_PROP_FPS, 30) 

# print( cap.get(cv2.CAP_PROP_FPS) )
# print( cap.get(cv2.CAP_PROP_FRAME_WIDTH) )
# print( cap.get(cv2.CAP_PROP_FRAME_HEIGHT) )
# print( cap.get(cv2.CAP_PROP_FRAME_COUNT) ) 


#"cap = cv2.VideoCapture('videotestsrc ! videoconvert ! appsink', cv2.CAP_GSTREAMER)
#cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
#cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

if cap.isOpened() == False:
    print('OpenError')
    sys.exit()
cv2.namedWindow("TAKAGO_LAB", cv2.WINDOW_NORMAL | cv2.WINDOW_GUI_NORMAL)
 
while True:
    ret, frame = cap.read()
    if ret==False:
        break
    cv2.imshow('TAKAGO_LAB',frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
 
cap.release()
cv2.destroyAllWindows()
for i in range (1,5):
    cv2.waitKey(1)