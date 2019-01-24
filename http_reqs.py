
import urllib.request
import re
from pprint import pprint
import json

def getChild(s):
    return s.split(">")[1].split("<")[0]

catlinks = [ '/youtube/top/category/comedy', '/youtube/top/category/animals'
            ,'/youtube/top/category/entertainment',
            '/youtube/top/category/games',
            '/youtube/top/category/music', '/youtube/top/category/news',
            '/youtube/top/category/education', '/youtube/top/category/howto','/youtube/top/category/tech']

cats = [c.split("/")[-1] for c in catlinks]

#Open and write format
file = open("channels.txt", "w")
file.write("index,link,cname,category,newsubs30d,newviews30d,sub_avg_14d,view_avg_14d\n")

user_agent = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7'
headers={'User-Agent':user_agent,}

sl=[]
errc = 0
ind = 0
for cat in cats:
    curl = 'https://socialblade.com/youtube/top/category/'+cat


    request=urllib.request.Request(curl,None,headers)
    response = urllib.request.urlopen(request)
    data = response.read()


    #Parse individual channels of category
    tcs = re.findall(r'"/youtube/c/.+?</a>|"/youtube/ch.+?</a>',str(data))
    cns = [(c.split('"')[1],c.split('>')[1].split('<')[0]) for c in tcs]


    for (cl,cn) in cns:
        try:
            uurl="https://socialblade.com"+cl
            request2=urllib.request.Request(uurl,None,headers)
            response2=urllib.request.urlopen(request2)
            data2=response2.read()

            c_dates=re.findall(r'<div style="float: left; width: 95px;">.+?</div>',str(data2))
            c_dates=[getChild(e).replace(" ","").replace("\\n","") for e in c_dates]
            c_days=re.findall(r'<div style="float: left; width: 20px; color:#9a9a9a; text-align: right; padding-right: 44px;">.+? </div>',str(data2))
            c_days=[getChild(e) for e in c_days]

            c_nsubs_nviews=re.findall(r'<span style="color:#41a200;">\+.+?</span>|<span style="color:#e53b00; font-weight: 600;">\-.+?</span>|<span style="color:#ccc;">\-.+?</span>',str(data2))
            c_nsubs_nviews=[getChild(e) for e in c_nsubs_nviews]

            c_subs_views=re.findall(r'<div style="width: 140px; float: left;">.+?</div>',str(data2))
            c_subs_views=[getChild(e).replace("\\n","") for e in c_subs_views]

            c_earnings=re.findall(r'<div style="float: left; width: 165px; height: 30px;">.+?</div>',str(data2))
            c_earnings=[getChild(e) for e in c_earnings]

            #Make dict date : (gained subs,gained views,totals,totalv)

            #Total subs,views gained in 30 days
            c_30d_total=c_nsubs_nviews[-2:]

            #Average daily sub,view growth in last 14 days
            c_14d_avg=c_nsubs_nviews[-4:-2]

            c_nsubs_nviews=c_nsubs_nviews[:-4]

            c_nsubs=c_nsubs_nviews[::2]
            c_nviews=c_nsubs_nviews[1::2]

            c_subs=c_subs_views[::2]
            c_views=c_subs_views[1::2]

            print("Handling "+cn)
            if len(c_nsubs)==14 and len(c_nviews)==14 and len(c_subs)==14 and len(c_views)==14:
                pass
            else:
                errc=errc+1
                if len(c_nsubs)==0:
                    continue
                break

            ind=ind+1
            personalinfo=(ind,c_nsubs,c_nviews,c_subs,c_views)
            dc=0
            sl.append([cn,cat,c_nsubs,c_nviews,c_subs,c_views,c_30d_total[0],c_30d_total[1],c_14d_avg[0],c_14d_avg[1],c_dates])
        except Exception as e:
            print("Exception happened")


    print("Total errors: "+str(errc))
    pprint(sl)



jf = open("date_data.json", "w")
jf.write(json.dumps(sl))
jf.close()


