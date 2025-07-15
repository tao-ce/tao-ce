## Purpose

some repositories need patching to be running with the current version.

Once software engineers would provide a suitable version, patching can be removed.

## Usage

1. stay at root of this repository

2. ensure to have sources installed with:
```
git submodule update --init --recursive
```

3. apply patches:
```
patch -p1 < hack/sources/portal.patch
patch -p1 < hack/sources/em.patch
```

## Create new patches

If you consider any app requires its own patch, use the following command (e.g. for `portal`):

```
git diff -p --src-prefix=a/apps/portal/src --dst-prefix=b/apps/portal/src

```

