import math

exponential = lambda: lambda n,b : [ 
        math.ceil(n**(float(k)/float(b)))
        for k in range(1, b)
        ] + [n]

normal = lambda m,s : lambda n,b : [ 
        math.ceil(n * (1.0 + math.erf(((float(k) / float(b)) - m ) / (s * math.sqrt(2.0)))) / 2.0)
        for k in range(1, b)
    ] + [n] 
      
linear = lambda : lambda n,b : [ math.ceil(k*n/b) for k in range(1,b) ] + [n]

instant = lambda : lambda n,b : [n] * b


if __name__ == "__main__":
    import sys
    import matplotlib.pyplot as plt
    import matplotlib
    import mplcyberpunk
    a = sys.argv.copy()
    u = int(a[1]) if len(a) > 1 else 100
    d = int(a[2]) if len(a) > 2 else 20
    ms = {
        'instant': instant(),
        'normal(.3,.1)': normal(0.3, 0.1),
        # 'normal(.7,.07)': normal(0.7, 0.07),
        'normal(.5,.2)': normal(0.5, 0.2),
        'linear': linear(),
        'exponential' :exponential(),
    }
    ds = { n: ms[n](u,d) for n in ms }

    print('| '+' |\n| '.join(
        [' | '.join([' time '] + [m for m in ms])]
        + [' | '.join([ '-'*(len(k)-1)+':' for k in [' time '] + [m for m in ms]])]
        + [
            ' | '.join([f'{t:>6}']+[f'{ds[m][t]:>{len(m)}}' for m in ds])
            for t in range(0,d)
        ])+' |')

    plt.style.use("cyberpunk")
    cmap = plt.cm.plasma
    colors = matplotlib.colors.Normalize(vmin=0, vmax=len(ds)-1)
    with plt.style.context('cyberpunk'):
        plt.xlabel('Time (in s)')
        plt.ylabel('Users')
        for i, m in enumerate(ds): 
            plt.plot(range(0,d), ds[m], marker='', c=cmap(colors(i)))
        plt.legend([m for m in ds])

        mplcyberpunk.make_lines_glow()
        plt.savefig(f'distributions-{u}-{d}.png', dpi=300)