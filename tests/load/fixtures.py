class TAOUserBank:    
    def __init__(self, *args, **kwargs):
        self.bank = kwargs.get('bank')
        self.hydrator = kwargs.get('hydrator')
        self.index = 0

    def __iter__(self):
        return self

    def __next__(self):
        return self.next()

    def next(self):
        if self.index < (len(self.bank)):
            cur, self.index = self.index, self.index + 1
            return self.hydrator(self.bank[cur])
        raise StopIteration()
