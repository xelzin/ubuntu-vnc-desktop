FROM dorowu/ubuntu-desktop-lxde-vnc:focal
EXPOSE 8555
EXPOSE 8444
EXPOSE 80
ENV KEYS="generate"
ENV PLOTS_DIR="/plots"
ENV USER="chia"
ENV HTTP_PASSWORD="chiapass"
ENV PASSWORD="chiapass123"
ARG BRANCH
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y git lsb-release
RUN echo "cloning $BRANCH"
WORKDIR /
RUN git clone --branch $BRANCH https://github.com/Chia-Network/chia-blockchain.git
RUN git clone --branch v.0.1.0 https://github.com/swar/Swar-Chia-Plot-Manager.git
ADD ./config.yaml /Swar-Chia-Plot-Manager/config.yaml
WORKDIR /chia-blockchain
ADD ./baseSetup.sh baseSetup.sh
RUN git submodule update --init mozilla-ca \
&& chmod +x install.sh \
&& sh ./install.sh
RUN mkdir /plots
RUN chmod +x baseSetup.sh && ./baseSetup.sh 
ADD ./entrypoint.sh entrypoint.sh
ADD ./chia-gui.desktop /usr/share/applications/chia-gui.desktop
ADD ./chia-manager.desktop /usr/share/applications/chia-manager.desktop
ADD ./runGUI.sh runGUI.sh
ADD ./runPlotManager.sh runPlotManager.sh
ADD ./setupPlotManager.sh setupPlotManager.sh
ADD ./chiaSetup.sh chiaSetup.sh
RUN chmod +x ./runGUI.sh && chmod +x ./runPlotManager.sh
RUN chmod +x ./setupPlotManager.sh && ./setupPlotManager.sh $USER
RUN chmod +x ./chiaSetup.sh && ./chiaSetup.sh
ENTRYPOINT ["./entrypoint.sh"]
