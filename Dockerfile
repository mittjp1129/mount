FROM centos:centos7

ENV OS_COMP="python-cinderclient" \
    OS_REPO_URL="https://github.com/openstack/python-cinderclient.git" \
    OS_REPO_BRANCH="master" \
    OS_COMP_1="brick-cinderclient-ext" \
    OS_REPO_URL_1="https://github.com/openstack/python-brick-cinderclient-ext.git" \
    OS_REPO_BRANCH_1="master"


RUN set -e && \
    set -x && \
    yum install -y \
        libffi \
        libffi-devel \
        libxml2 \
        libxslt \
        sysfsutils \
        scsi-target-utils \
        iscsi-initiator-utils \
        targetcli \
        file \
        xfsprogs \
        e2fsprogs && \
    yum install -y \
        gcc \
        git \
        kernel-lt \
        kernel-lt-headers \
        python-devel \
        libxml2-devel \
        libxslt-devel \
        postgresql-devel \
        openssl-devel && \
    yum clean all && \
    mkdir -p /opt/stack && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    pip install -U pip && \
    git clone -b ${OS_REPO_BRANCH} --depth 1 ${OS_REPO_URL} /opt/stack/${OS_COMP} && \
    pip --no-cache-dir install -r /opt/stack/${OS_COMP}/requirements.txt && \
    pip --no-cache-dir install /opt/stack/${OS_COMP} && \
    git clone -b ${OS_REPO_BRANCH_1} --depth 1 ${OS_REPO_URL_1} /opt/stack/${OS_COMP_1} && \
    pip --no-cache-dir install -r /opt/stack/${OS_COMP_1}/requirements.txt && \
    pip --no-cache-dir install /opt/stack/${OS_COMP_1} && \
    yum clean all

RUN echo "InitiatorName=iqn.1994-05.com:c414533c615" > /etc/iscsi/initiatorname.iscsi

WORKDIR /opt/stack/${OS_COMP_1}
