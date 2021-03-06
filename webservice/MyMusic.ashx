﻿<%@ WebHandler Language="C#" Class="MyMusic" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;


public class MyMusic : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string s = context.Request.Params["s"] == null ? "" : context.Request.Params["s"].ToString();
           if (s == "") { s = "陈奕迅"; }
            context.Response.ContentType = "text/json";
            List<Song> songlist = MusicApis.SearchApi(s, "1", "0", "20").Cast<Song>().ToList();
            List<onesongnew> songl = new List<onesongnew>();
            foreach (Song song in songlist)
            {
                onesongnew onesong = new onesongnew();
                onesong.title = song.Name;
                onesong.author = song.Artist[0].Name;
                onesong.url = song.Mp3Url;
                onesong.pic = song.Album.PictureUrl;
                onesong.lrc = MusicApis.LyricInfo(song.Id.ToString()).Lyr;
                songl.Add(onesong);
            }

            context.Response.Write(Utils.ObjectToJson(songl));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}