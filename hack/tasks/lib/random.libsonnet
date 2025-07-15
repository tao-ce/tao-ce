local COLLECTIONS = import './datasets/collections.libsonnet';

function(seed="",precision=8) {
    PRECISION:: precision,
    MAX::  std.parseHex(std.repeat("f", self.PRECISION)),

    seed:: function(x="") std.sha256(std.toString(x)+seed)[1:1+self.PRECISION],

    pick:: function(x="",collection=[false,true]) collection[std.parseHex(self.seed(x)) % std.length(collection)],
    
    bool:: self.pick,
    int:: function(x="",mod=0) local i = std.parseHex(self.seed(x)); if mod > 0 then i % mod else i,
    mantis:: function(x="") std.parseHex(self.seed(x)) / self.MAX,
    base64:: function(x="",size=256)
        std.foldl(function(t,u)
            t
            + self.pick(x+"-"+u+"-"+1,COLLECTIONS.base64)
            + self.pick(x+"-"+u+"-"+2,COLLECTIONS.base64)
            + self.pick(x+"-"+u+"-"+3,COLLECTIONS.base64)
            + self.pick(x+"-"+u+"-"+4,COLLECTIONS.base64)
            , std.range(1,std.floor(size/3)),"")
        +  [
                "",
                self.pick(x+"-p1",COLLECTIONS.base64) + self.pick(x+"-p2",COLLECTIONS.base64mask2) + "==",
                self.pick(x+"-p1",COLLECTIONS.base64) + self.pick(x+"-p2",COLLECTIONS.base64) + self.pick(x+"-p3",COLLECTIONS.base64mask4) + "=",
            ][size%3]
        ,
    // test::function(p,samplesCount=1000,max=1000)
    //     {   
    //         local samples = [
    //             pseudoRandomGenerator(precision=p).int(k,mod=max)
    //             for k in std.range(0,samplesCount)
    //         ],
    //         precision: p,
    //         mean: std.sum(samples)/samplesCount,
    //         var:  std.foldl(function(v,x) v + std.pow(x - self.mean, 2),samples,0) / samplesCount,
    //         sigma: std.sqrt( self.var),
    //     }
}
