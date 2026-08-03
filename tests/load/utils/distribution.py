import math

exponential = lambda: lambda n,b : [ 
        math.ceil(n**(float(k)/float(b)))
        for k in range(1, b)
        ] + [n]

normal = lambda m,s : lambda n,b : [ 
        math.ceil(n * (1.0 + math.erf(((float(k) / float(b)) - m ) / (s * math.sqrt(2.0)))) / 2.0)
        for k in range(0, b-1)
    ] + [n] 
      
linear = lambda : lambda n,b : [ math.ceil(k*n/b) for k in range(1,b) ] + [n]

instant = lambda : lambda n,b : [n] * b


if __name__ == "__main__":
    import sys
    import matplotlib.pyplot as plt
    import matplotlib
    import mplcyberpunk

    from labellines import labelLine, labelLines

    a = sys.argv.copy()
    u = int(a[1]) if len(a) > 1 else 100
    d = int(a[2]) if len(a) > 2 else 20
    ms = {
        'instant': instant(),
        'linear': linear(),
        'exponential' :exponential(),
    } | {
        f'normal({.1+float(s)/10.0:.02},{float(s)/20.0})': normal(.1+float(s)/10.0, float(s)/20.0)
        for s in range(1,5)
    }

    xs = {
        'instant': d*0.1,
        'linear': d*0.75,
        'exponential': d*0.75,
    } | {
        f'normal({.1+float(s)/10.0:.02},{float(s)/20.0})': d*(0.1+s*0.1)
        for s in range(1,5)
    }
    ds = { n: ms[n](u,d) for n in ms }

    print('| '+' |\n| '.join(
        [' | '.join([' time '] + [g for m in ms for g in [m,'  Δ  ']])]
        + [' | '.join(
            [ '-'*k+':' 
                for k in [ 5 ] + [g for m in ms for g in [len(m)-1, 4]]
            ])]
        + [
            ' | '.join(
                [f'{t:>6}']
                +[ g 
                    for m in ds 
                    for g in [
                    f'{ds[m][t]:>{len(m)}}',                                # count cell
                    f'{ds[m][t] if t == 0 else ds[m][t] - ds[m][t-1]:+5}'   # delta cell
                ]])
            for t in range(0,d)
        ])+' |')

    plt.style.use("cyberpunk")
    cmap = plt.cm.plasma
    colors = matplotlib.colors.Normalize(vmin=-2, vmax=len(ds)-1)
    with plt.style.context('cyberpunk'):
        plt.xlabel('Time (in s)')
        plt.ylabel('Users')
        for i, m in enumerate(ds): 
            plt.plot(range(0,d), ds[m], marker='',label=m, c=cmap(colors(i)))
            labelLine(plt.gca().get_lines()[-1],xs[m])

        mplcyberpunk.make_lines_glow()
        plt.savefig(f'distributions-{u}-{d}.png', dpi=300)