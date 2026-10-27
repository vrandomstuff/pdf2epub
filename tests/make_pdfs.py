from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from PIL import Image, ImageDraw, ImageFont
import os

tests_dir = r'C:\Users\vtf62\code\pdf-to-epub\tests'
os.makedirs(tests_dir, exist_ok=True)

# Create a placeholder image
img_path = os.path.join(tests_dir, 'placeholder.png')
img = Image.new('RGB', (400, 200), color=(200, 220, 240))
d = ImageDraw.Draw(img)
try:
    font = ImageFont.truetype("arial.ttf", 24)
except Exception:
    font = ImageFont.load_default()
d.text((50, 80), "Placeholder Image", fill=(50, 50, 50), font=font)
img.save(img_path)

# PDF 1: with character data (extractable text)
pdf1 = os.path.join(tests_dir, 'with_character_data.pdf')
c = canvas.Canvas(pdf1, pagesize=letter)
c.setFont("Helvetica", 16)
c.drawString(72, 720, "Document with Character Data")
c.setFont("Helvetica", 12)
text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " * 10
y = 680
for i in range(0, len(text), 80):
    if y < 200:
        break
    c.drawString(72, y, text[i:i+80])
    y -= 14
c.drawImage(img_path, 72, y-200, width=400, height=200)
c.save()
print('created', pdf1)

# PDF 2: without character data (text rasterized as image)
pdf2 = os.path.join(tests_dir, 'without_character_data.pdf')
text_img = Image.new('RGB', (500, 300), color=(255, 255, 255))
d2 = ImageDraw.Draw(text_img)
try:
    font2 = ImageFont.truetype("arial.ttf", 20)
except Exception:
    font2 = ImageFont.load_default()
placeholder = "This is placeholder text rendered as an image.\nNo selectable character data.\n" * 6
d2.multiline_text((30, 30), placeholder, fill=(0, 0, 0), font=font2)
text_img_path = os.path.join(tests_dir, 'text_placeholder.png')
text_img.save(text_img_path)

c2 = canvas.Canvas(pdf2, pagesize=letter)
c2.setFont("Helvetica", 16)
c2.drawString(72, 720, "Document without Character Data")
c2.drawImage(text_img_path, 72, 400, width=500, height=300)
c2.drawImage(img_path, 72, 150, width=400, height=200)
c2.save()
print('created', pdf2)
