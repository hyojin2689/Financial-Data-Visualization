!pip install Konlpy
from konlpy.tag import Okt
from wordcloud import WordCloud, STOPWORDS
from collections import Counter
import pandas as pd

#word는 크롤링으로 얻어진 데이터에서 블로그 제목만 가져와서 넣어놓은 것
#단어추출
final=[]
for i in range(0,2100):
   list_n=okt.nouns(word[i])
   final=final+list_n
   
#글자의 길이가 1이면 버리기
final = [n for n in final if len(n) > 1]

#단어 갯수 카운트 한 뒤 상위 100개 단어추출
count = Counter(final)
top_100 = count.most_common(100)

#워드클라우드 그리기
wordcloud = WordCloud(font_path='NanumGothic.ttf',background_color='white', width=800, height=603,max_font_size=125)
cloud = wordcloud.generate_from_frequencies(dict(top_100))
plt.figure(figsize=(10,8))
plt.imshow(wordcloud)
plt.tight_layout(pad=0)
plt.axis('off')
plt.show()
