import 'dart:html';

import 'dart:typed_data';

var initialized = false;

final VideoElement video = VideoElement();
final CanvasElement canvas = CanvasElement();

Future<bool> requestCamera() async {
  if (initialized) {
    print('Already init');
    return true;
  }

  try {
    final mediaStream = await window.navigator.mediaDevices!
        .getUserMedia({'video': true, 'audio': false});
    video.srcObject = mediaStream;
    await video.play();
    initialized = true;
    return true;
  } on DomException catch (e) {
    print('Error: ${e.message}');
  }
  return false;
}

Uint8List takePic() {
  assert(initialized);

  final context = canvas.context2D;

  canvas.width = video.videoWidth;
  canvas.height = video.videoHeight;
  context.drawImage(video, 0, 0);

  final data = canvas.toDataUrl('image/png');
  final uri = Uri.parse(data);
  return uri.data!.contentAsBytes();
}
