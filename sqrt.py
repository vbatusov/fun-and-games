def mysqrt(num, margin = 0.00000001):
    lo, hi = (0.0, float(num))
    root = 0.0

    while True:
        root = (lo + hi) / 2
        error = root*root - num
        #print("Current root: ", root, ", current error: ", error)
        if error > 0: # root too big
            hi = root
        else: # root too small
            lo = root
        if abs(error) <= margin:
            break

    return root

if __name__ == "__main__":
    import math
    print("real: ", math.sqrt(10))
    print("mine: ", mysqrt(10))
